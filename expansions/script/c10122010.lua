--幻灭梦魇 反乌托邦的末日神
function c10122010.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1) 
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c10122010.atkval)
	c:RegisterEffect(e2)  
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(10122010,0))
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10122010.discon)
	e2:SetTarget(c10122010.distg)
	e2:SetOperation(c10122010.disop)
	c:RegisterEffect(e2)   
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10122010,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c10122010.drcon)
	e3:SetTarget(c10122010.drtg)
	e3:SetOperation(c10122010.drop)
	c:RegisterEffect(e3) 
end

function c10122010.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end

function c10122010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tg=Duel.GetMatchingGroup(c10122010.tgfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,tg:GetCount(),tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function c10122010.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c10122010.tgfilter,tp,LOCATION_REMOVED,0,nil)
	if tg:GetCount()>0 and Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)~=0 then
	 Duel.ShuffleDeck(tp)
	 Duel.Draw(tp,2,REASON_EFFECT)
	end
end

function c10122010.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc333) and c:IsAbleToDeck()
end

function c10122010.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0xc333) and re:GetHandler():IsType(TYPE_FIELD) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) 
end

function c10122010.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end

function c10122010.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	if re:GetHandler():IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0 and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10122010,1)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	   local sg=dg:Select(tp,1,1,nil) 
	   Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)   
	end
end

function c10122010.atkval(e,c)
	return Duel.GetMatchingGroupCount(c10122010.atkfilter,c:GetControler(),LOCATION_REMOVED,0,nil)*800
end

function c10122010.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc333) 
end
