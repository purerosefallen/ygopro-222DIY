--生 命 的 二 刀 流
--庭 师 生 日 快 乐 ！
local m=46560404
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsType,TYPE_FUSION),aux.FilterBoolFunction(Card.IsAttackAbove,2500),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--ATK Up
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	e4:SetOperation(cm.atkop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(cm.rmcon)
	e5:SetTarget(cm.rmtg)
	e5:SetOperation(cm.rmop)
	c:RegisterEffect(e5)
end
function cm.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function cm.spfilter1(c,fc,tp)
	return c:IsType(TYPE_FUSION) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_GRAVE,0,1,c)
end
function cm.spfilter2(c,fc)
	return c:IsAttackAbove(2500) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_GRAVE,0,1,nil,c,tp) and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_GRAVE,0,1,nil,c)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g1=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local g2=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
end
function cm.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local sel=1
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,0,LOCATION_HAND,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(m,3))
	if g:GetCount()>1 then
		sel=Duel.SelectOption(1-tp,1213,1214)
	else
		sel=Duel.SelectOption(1-tp,1214)+1
	end
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
		local sg1=g:Select(1-tp,2,2,nil)
		Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_DISCARD)
		Duel.NegateEffect(0) return end
	local mg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if mg:GetCount()>0 then
	   local sg2=mg:Select(tp,1,2,nil)
	   Duel.HintSelection(sg2)
	   Duel.Remove(sg2,POS_FACEUP,REASON_EFFECT)
	end
end
