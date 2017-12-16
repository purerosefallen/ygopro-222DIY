--古 圣 树 的 默 许
local m=46564066
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,465640661)
	e2:SetCost(cm.damcost)
	e2:SetTarget(cm.damtg)
	e2:SetOperation(cm.damop)
	c:RegisterEffect(e2)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return tc and tc:IsFaceup() and tc:IsControler(tp) and tc:IsSetCard(0x65c)
end
function cm.filter2(c,e,tp,ac,bc)
	local mg=Group.FromCards(ac,bc)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and cm.CheckFusionMaterialExact(c,mg,tp)
end
function cm.CheckFusionMaterialExact(c,g,chkf)
	aux.FCheckAdditional=cm.HoldGroup(g)
	local res=c:CheckFusionMaterial(g,nil,chkf)
	aux.FCheckAdditional=nil
	return res
end
function cm.HoldGroup(mg)
	return function(tp,g,fc)
		return not (g:IsExists(cm.HoldGroupFilter,1,nil,mg) or mg:IsExists(cm.HoldGroupFilter,1,nil,g))
	end
end
function cm.HoldGroupFilter(c,mg)
	return not mg:IsContains(c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ac=Duel.GetAttackTarget()
		local bc=Duel.GetAttacker()
		if not bc then return false end
		return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,ac,bc)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttackTarget()
	local bc=Duel.GetAttacker()
	if ac and bc and ac:IsRelateToBattle() and bc:IsRelateToBattle() and not ac:IsImmuneToEffect(e) and not bc:IsImmuneToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,ac,bc)
		local tc=g:GetFirst()
		if not tc then return end
		local mg=Group.FromCards(ac,bc)
		tc:SetMaterial(mg)
		Duel.SendtoGrave(mg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.damfilter(c)
	return c:IsSetCard(0x65c) and c:GetLevel()>0
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.damfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.damfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.damfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetLevel()*200)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Damage(1-tp,tc:GetLevel()*200,REASON_EFFECT)
	end
end
