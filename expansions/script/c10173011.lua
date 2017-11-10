--钢龙剑
function c10173011.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c10173011.hspcon)
	e1:SetOperation(c10173011.hspop)
	c:RegisterEffect(e1) 
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173011,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10173011)
	e2:SetTarget(c10173011.tdtg)
	e2:SetOperation(c10173011.tdop)
	c:RegisterEffect(e2)  
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10173011,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10173011.discon)
	e3:SetCost(c10173011.discost)
	e3:SetTarget(c10173011.distg)
	e3:SetOperation(c10173011.disop)
	c:RegisterEffect(e3) 
end
function c10173011.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c10173011.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10173011.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10173011.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c10173011.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c10173011.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c10173011.cfilter(c)
	return bit.band(c:GetType(),0x40002)==0x40002 and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function c10173011.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsRace(RACE_DRAGON) or bit.band(chkc:GetType(),0x40002)==0x40002) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_REMOVED) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(c10173011.tdfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c10173011.tdfilter,tp,LOCATION_REMOVED,0,1,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10173011.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
	   Duel.ShuffleDeck(tp)
	   Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c10173011.tdfilter(c)
	return (c:IsRace(RACE_DRAGON) or bit.band(c:GetType(),0x40002)==0x40002) and c:IsFaceup() and c:IsAbleToDeck()
end
function c10173011.spfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c10173011.hspcon(e,c)
	if c==nil then return true end
	local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c10173011.spfilter,c:GetControler(),LOCATION_MZONE+LOCATION_HAND,0,c)
	if ft>0 then return
	   g:GetCount()>=2
	else return
	   g:GetCount()>=2 and g:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE)
	end
end
function c10173011.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft,sg=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.GetMatchingGroup(c10173011.spfilter,c:GetControler(),LOCATION_MZONE+LOCATION_HAND,0,c)
	if ft>0 then
	   sg=g:Select(tp,2,2,nil)
	else
	   sg=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
	   g:Sub(sg)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	   local sg2=g:Select(tp,1,1,nil)
	   sg:Merge(sg2)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
