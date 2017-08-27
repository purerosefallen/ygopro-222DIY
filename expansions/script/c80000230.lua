--口袋妖怪 炎武王
function c80000230.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1) 
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,80000230)
	e3:SetCondition(c80000230.drcon)
	e3:SetTarget(c80000230.drtg)
	e3:SetOperation(c80000230.drop)
	c:RegisterEffect(e3)
	--dont
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(0,1)
	e12:SetTarget(c80000230.splimit)
	c:RegisterEffect(e12)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000230,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c80000230.cost)
	e4:SetTarget(c80000230.target)
	e4:SetOperation(c80000230.operation)
	c:RegisterEffect(e4)   
end
c80000230.lvdncount=2
c80000230.lvdn={80000229,80000228}
function c80000230.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c80000230.filter(c)
	return c:GetCode()==80000228 and c:IsAbleToHand()
end
function c80000230.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000230.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80000230.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c80000230.filter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c80000230.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE)
end
function c80000230.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c80000230.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80000230.cfilter,1,nil,tp)
end
function c80000230.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x2d0)
end
function c80000230.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c80000230.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		if Duel.SelectOption(tp,aux.Stringid(80000230,3),aux.Stringid(80000230,4))==0 then
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		else
			Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
		end
	end
end