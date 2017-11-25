--博丽神社的巫女小姐
function c1156009.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),2,4)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c1156009.splimit0)
	c:RegisterEffect(e0)  
--  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1156009.con1)
	e1:SetOperation(c1156009.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetTarget(c1156009.tg2)
	e2:SetOperation(c1156009.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_MSET)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c1156009.con3)
	e3:SetTargetRange(0,1)
	e3:SetTarget(aux.TRUE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetTarget(c1156009.sumlimit6)
	c:RegisterEffect(e6)
--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_TRIGGER)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,LOCATION_SZONE)
	e7:SetCondition(c1156009.con7)
	e7:SetTarget(c1156009.tg7)
	c:RegisterEffect(e7)
--
end
--
function c1156009.splimit0(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
--
function c1156009.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK 
end
--
function c1156009.ofilter1(c)
	return c:IsAbleToHand()
end
function c1156009.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(1156009,0)) then
		Duel.Hint(HINT_CARD,0,1156009)
		local g=Duel.GetMatchingGroupCount(c1156009.ofilter1,tp,0,LOCATION_ONFIELD,nil) 
		if g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg=Duel.SelectMatchingCard(tp,c1156009.ofilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end
--
function c1156009.tfilter2(c,tp)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_EXTRA) and c:GetSummonPlayer()~=tp and c:IsAbleToDeck() and c:IsLocation(LOCATION_MZONE)
end
function c1156009.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return eg:IsExists(c1156009.tfilter2,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD)
end
--
function c1156009.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c1156009.tfilter2,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
--
function c1156009.cfilter3(c)
	return c:IsType(TYPE_MONSTER)
end
function c1156009.con3(e)
	return e:GetHandler():GetLinkedGroup():FilterCount(c1156009.cfilter3,nil)==0
end
--
function c1156009.sumlimit6(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
--
function c1156009.con7(e)
	return Duel.GetTurnPlayer()==e:GetHandler():GetControler()
end
--
function c1156009.tg7(e,c)
	return c:IsFacedown()
end
--
