--点兔 天天座理世
local m=50008202
local cm=_G["c"..m]
local mil=require("expansions/script/Millux")
cm.is_series_with_rabbit=true
function cm.initial_effect(c)
	mil.rabat_return(c,m,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget( 
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
	end)
	e1:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		Duel.SortDecktop(tp,tp,3)
	end)
	c:RegisterEffect(e1)
	--meet
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m..1)
	e2:SetCondition(mil.return_con)
	e2:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and chkc:IsAbleToDeck() end
		if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
	end)
	e2:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e2)
end
