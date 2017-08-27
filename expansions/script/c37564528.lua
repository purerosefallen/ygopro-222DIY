--Yamanobori Kibun
local m=37564528
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	Senya.NanahiraTrap(c,e1)
end
function cm.filter1(c,tp)
	return c:IsCode(37564765) and c:IsPosition(POS_FACEUP_ATTACK) and c:IsAttackable() and Duel.IsExistingTarget(cm.filter2,tp,0,LOCATION_MZONE,1,c,c)
end
function cm.filter2(c,tc)
	return c:IsCanBeBattleTarget(tc)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
	local ac=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g2=Duel.SelectTarget(tp,cm.filter2,tp,0,LOCATION_MZONE,1,1,ac,ac)
	e:SetLabelObject(ac)
end
function cm.cf(c,e)
	return not c:IsRelateToEffect(e)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()>1 and not g:IsExists(cm.cf,1,nil,e) then
		local tc=g:GetFirst()
		local sc=g:GetNext()
		local ac=e:GetLabelObject()
		if tc==ac then tc=sc end
		if ac:GetOriginalCode()==37564765 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(cm.efilter)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
			ac:RegisterEffect(e1)
		end
		if tc:GetOriginalCode()==37564765 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(cm.efilter)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
			tc:RegisterEffect(e1)
		end
		if ac:IsAttackable() then Duel.CalculateDamage(ac,tc) end
	end
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end