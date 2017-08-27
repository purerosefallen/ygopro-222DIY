--Setsukka -Sawawa Remix-
local m=37564233
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_sawawa=true
cm.Senya_name_with_remix=true
function cm.initial_effect(c)
	Senya.SawawaCommonEffect(c,1,true,false,false)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m)
	e5:SetCondition(Senya.CheckNoExtra)
	e5:SetCost(Senya.SawawaRemoveCost(1))
	e5:SetTarget(cm.destg)
	e5:SetOperation(cm.desop)
	c:RegisterEffect(e5)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.dfilter(c,e)
	return c:IsAbleToChangeControler() and not c:IsImmuneToEffect(e)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then b1=b1+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then b1=b1+1 end
	local g=Duel.GetMatchingGroup(cm.dfilter,tp,0,LOCATION_SZONE,nil,e)
	local ct=g:GetCount()
	if chk==0 then return b1>0 and ct>0 end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local b1=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then b1=b1+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then b1=b1+1 end
	local g=Duel.GetMatchingGroup(cm.dfilter,tp,0,LOCATION_PZONE,nil,e)
	local ct=g:GetCount()
	if not (b1>0 and ct>0) then return end
	if b1>=ct then
		local tc=g:GetFirst()
		while tc do
			--Senya.ExileCard(tc)
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			tc=g:GetNext()
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		--Duel.SendtoDeck(tc,nil,-1,REASON_RULE)
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function cm.filter(c)
	return c:IsAbleToRemove()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_PZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_PZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_PZONE,0,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end