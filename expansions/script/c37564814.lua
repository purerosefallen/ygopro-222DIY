--3L·月时针
local m=37564814
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_CONFIRM)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
end
function cm.effect_operation_3L(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(function(e)
		local c=e:GetHandler()
		return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and c:IsRelateToBattle() and c:GetBattleTarget()
	end)
	e1:SetValue(function(e)
		return math.max(e:GetHandler():GetBattleTarget():GetAttack(),0)
	end)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	return e1
end
function cm.filter2(c,e,tp,bc)
	local mg=Group.FromCards(e:GetHandler(),bc)
	return Senya.check_set_3L(c) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Senya.CheckFusionMaterialExact(c,mg,tp)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local bc=c:GetBattleTarget()
		if not bc then return false end
		return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,bc)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsRelateToBattle() and c:IsRelateToBattle() and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) and not bc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,bc)
		local tc=g:GetFirst()
		if not tc then return end
		local mg=Group.FromCards(c,bc)
		tc:SetMaterial(mg)
		Duel.SendtoGrave(mg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end