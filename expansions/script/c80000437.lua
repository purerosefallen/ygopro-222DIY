--ＰＭ 音波龙
function c80000437.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()  
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	e1:SetCountLimit(1,80000437)
	e1:SetCondition(c80000437.spcon)
	e1:SetOperation(c80000437.spop)
	c:RegisterEffect(e1)  
	--confirm
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c80000437.target)
	e2:SetOperation(c80000437.operation)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(c80000437.con)
	c:RegisterEffect(e3)
end
function c80000437.con(e)
	return not Duel.IsExistingMatchingCard(Card.IsAttackPos,e:GetHandler():GetControler(),0,LOCATION_MZONE,1,nil)
end
function c80000437.spcon(e,c)
	if c==nil then return true end
	local g=Duel.GetReleaseGroup(c:GetControler())
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-2
		and g:GetCount()>1 and g:IsExists(Card.IsCode,1,nil,80000436,86569121)
end
function c80000437.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetReleaseGroup(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg1=g:FilterSelect(tp,Card.IsCode,1,1,nil,80000436,86569121)
	g:RemoveCard(sg1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg2=g:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	Duel.Release(sg1,REASON_COST)
end
function c80000437.filter(c)
	return (c:IsOnField() and c:IsFacedown()) or (c:IsLocation(LOCATION_HAND) and not c:IsPublic())
end
function c80000437.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000437.filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
	Duel.SetChainLimit(c80000437.chainlm)
end
function c80000437.chainlm(e,rp,tp)
	return tp==rp
end
function c80000437.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80000437.filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleHand(1-tp)
end