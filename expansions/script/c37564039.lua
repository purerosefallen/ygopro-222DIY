--Glitter -Starving Trancer Remix-
local m=37564039
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_rose=true
cm.Senya_name_with_remix=true
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.chk then
		cm.chk=true
		local ex=Effect.GlobalEffect()
		ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ex:SetCode(EVENT_ADJUST)
		ex:SetOperation(cm.reg)
		Duel.RegisterEffect(ex,0)
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,0xff,0xff,nil)
	return g:GetCount()>0
end
function cm.reg(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,0xff,0xff,nil)
	g:ForEach(function(c)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(m,0))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCountLimit(1)
		e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return Duel.GetTurnPlayer()==tp and e:GetHandler():GetOverlayGroup():IsExists(aux.FilterEqualFunction(Card.GetOriginalCode,m),1,nil)
		end)
		e3:SetTarget(cm.mttg)
		e3:SetOperation(cm.mtop)
		c:RegisterEffect(e3,true)
		c:RegisterFlagEffect(m,0,0,1)
	end)
end
function cm.rfilter(c)
	return c:IsType(TYPE_XYZ) and c:GetFlagEffect(m)==0
end
function cm.mtfilter(c)
	return Senya.check_set_elem(c)
end
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and Senya.check_set_elem(c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

