--请问您今天要来看雪景吗
local m=50008211
local cm=_G["c"..m]
local mil=require("expansions/script/Millux")
cm.is_series_with_rabbit=true
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,function(c)
		return mil.is_series(c,'rabbit')
	end,2,2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk)   
		if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>2 and Duel.IsPlayerCanDraw(tp,1) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
		local op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
		e:SetLabel(op)
	end)
	e1:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		Duel.ConfirmCards(1-tp,g)
		local tpe=0
		if e:GetLabel()==0 then 
			tpe=TYPE_FUSION 
		elseif e:GetLabel()==1 then
			tpe=TYPE_SYNCHRO 
		elseif e:GetLabel()==2 then
			tpe=TYPE_XYZ
		else tpe=TYPE_LINK 
		end
		local sg=g:Filter(Card.IsType,nil,tpe)
		local ct=sg:GetClassCount(Card.GetCode)
		if ct>2 then
			local drmum = Duel.Draw(tp,1,REASON_EFFECT)
			local rthg=Duel.GetMatchingGroup(cm.rthfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
			if drmun~=0 and rthg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then 
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
				local rthgs=rthg:Select(tp,1,1,nil)
				Duel.SendtoHand(rthgs,nil,REASON_EFFECT)
			end
		end
	end)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,5))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
		if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,3,e:GetHandler) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,3,3,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	end)
	e2:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_EXTRA)
		if ct==3 then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
			if g:GetCount()>1 then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
				local sg=g:Select(tp,2,2,nil)
				Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
				Duel.SortDecktop(tp,tp,2)
			else 
				local hg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
				local ct=Duel.SendtoDeck(hg,nil,0,REASON_EFFECT)
				Duel.SortDecktop(tp,tp,ct)
			end
		end
	end)
	c:RegisterEffect(e2)
end
function cm.rthfilter(c)
	return c:IsFaceup() and mil.is_series(c,'rabbit')
end
function cm.filter(c)
	return mil.is_series(c,'rabbit') and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end