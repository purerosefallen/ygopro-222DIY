--uta
local m=37564318
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_jysp=1
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_STANDBY_PHASE)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	end)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)>0 then return end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	local check_box=Senya.order_table_new({
	[LOCATION_HAND]=0,
	[LOCATION_ONFIELD]=0,
	[LOCATION_GRAVE]=0})
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetLabel(check_box)
	e1:SetCondition(cm.drcon1)
	e1:SetOperation(cm.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_REMOVE)
	e2:SetLabel(check_box)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetLabel(check_box)
	e3:SetOperation(cm.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.filter(c,tp,l)
	return c:IsPreviousLocation(l) and c:GetPreviousControler()==tp
end
function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return not re or not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.drop1(e,tp,eg,ep,ev,re,r,rp)
	local t=Senya.order_table[e:GetLabel()]
	for loc,sct in pairs(t) do
		if eg:IsExists(cm.filter,1,nil,tp,loc) and sct<2 then cm.op[loc](e,tp) end
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local t=Senya.order_table[e:GetLabel()]
	for loc,sct in pairs(t) do
		if eg:IsExists(cm.filter,1,nil,tp,loc) and sct<2 then t[loc]=1 end
	end
end
function cm.drop2(e,tp,eg,ep,ev,re,r,rp)
	local t=Senya.order_table[e:GetLabel()]
	for loc,sct in pairs(t) do
		if sct==1 then
			cm.op[loc](e,tp)
			if t[loc]<2 then t[loc]=0 end
		end
	end
end

function cm.sfilter(c,e,tp)
	if c:IsType(TYPE_MONSTER) then
		return c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else
		return (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable()
	end
end
cm.op={
[LOCATION_HAND]=function(e,tp)
	if Duel.IsPlayerCanDraw(tp,2) then
		Senya.order_table[e:GetLabel()][LOCATION_HAND]=2
		Duel.Hint(HINT_CARD,0,m)
		Duel.Draw(tp,2,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(g:GetFirst():GetControler())
	end
end,
[LOCATION_ONFIELD]=function(e,tp)
	if Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) then
		Senya.order_table[e:GetLabel()][LOCATION_ONFIELD]=2
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g:GetFirst():IsType(TYPE_MONSTER) then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		else
			Duel.SSet(tp,g)
		end
		Duel.ConfirmCards(1-tp,g)
	end
end,
[LOCATION_GRAVE]=function(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		Senya.order_table[e:GetLabel()][LOCATION_GRAVE]=2
		Duel.Hint(HINT_CARD,0,m)
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end,
}
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
