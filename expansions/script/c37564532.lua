--SUPER SONIC
local m=37564532
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,cm.synfilter,aux.NonTuner(cm.synfilter),1)
	c:EnableReviveLimit()
	Senya.Nanahira(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.settg)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	if not cm.chk then
		cm.chk=true
		local g=Group.CreateGroup()
		g:KeepAlive()
		local ex=Effect.GlobalEffect()
		ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ex:SetCode(EVENT_ADJUST)
		ex:SetLabelObject(g)
		ex:SetOperation(cm.reg)
		Duel.RegisterEffect(ex,0)
	end
end
function cm.f(c)
	return c:IsFacedown() and c:GetType()==TYPE_SPELL and c:GetActivateEffect()
end
function cm.add(rg)
	return function(tc)
		local te=tc:GetActivateEffect()
		if not te then return end
		local pr1,pr2=te:GetProperty()
		if bit.band(pr2,EFFECT_FLAG2_COF)~=0 then return end
		pr2=bit.bor(pr2,EFFECT_FLAG2_COF)
		te:SetHintTiming(0,0x1e0)
		te:SetProperty(pr1,pr2)
		rg:AddCard(tc)
	end
end
function cm.rmv(rg)
	return function(tc)
		local te=tc:GetActivateEffect()
		if not te then return end
		local pr1,pr2=te:GetProperty()
		pr2=pr2-bit.band(pr2,EFFECT_FLAG2_COF)
		te:SetProperty(pr1,pr2)
		te:SetHintTiming(0,0)
		rg:RemoveCard(tc)
	end
end
function cm.reg(e,tp,eg,ep,ev,re,r,rp)
	local rg=e:GetLabelObject()
	for i=0,1 do
		local rg2=rg:Filter(Card.IsControler,nil,i)
		if Duel.IsPlayerAffectedByEffect(i,m) then
			rg2:ForEach(function(tc)
				if tc:IsLocation(LOCATION_SZONE) and cm.f(tc) then return end
				cm.rmv(rg)(tc)
			end)
			local g=Duel.GetMatchingGroup(cm.f,i,LOCATION_SZONE,0,nil)
			g:Sub(rg)
			g:ForEach(cm.add(rg))
		else
			rg2:ForEach(cm.rmv(rg))
		end
	end
end
function cm.synfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.filter(c)
	return c:GetType()==TYPE_SPELL and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end