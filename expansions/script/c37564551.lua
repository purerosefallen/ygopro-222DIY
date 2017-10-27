--Hardcore Forte
local m=37564551
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	--Senya.nntr(c)
	--spell
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_ACTIVATE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0x3c0)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e6:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return not Duel.CheckEvent(EVENT_CHAINING) and Senya.NanahiraExistingCondition(false)(e,tp)
	end)
	e6:SetTarget(cm.scopytg)
	e6:SetOperation(cm.CopyOperation)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_ACTIVATE)
	e7:SetCode(EVENT_CHAINING)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e7:SetCondition(Senya.NanahiraExistingCondition(false))
	e7:SetTarget(cm.CopySpellChainingTarget)
	e7:SetOperation(cm.CopyOperation)
	c:RegisterEffect(e7)
	Senya.NanahiraTrap(c,e6,e7)
	--monster
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(Senya.DescriptionInNanahira(6))
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
	e8:SetHintTiming(0x3c0)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e8:SetCountLimit(1,1)
	e8:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return not Duel.CheckEvent(EVENT_CHAINING)
	end)
	e8:SetCost(Senya.ForbiddenCost())
	e8:SetTarget(cm.scopytg3)
	e8:SetOperation(cm.CopyOperation)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(Senya.DescriptionInNanahira(6))
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_CHAINING)
	e9:SetRange(LOCATION_MZONE)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e9:SetCountLimit(1,1)
	e9:SetCost(Senya.ForbiddenCost())
	e9:SetTarget(cm.scopytg4)
	e9:SetOperation(cm.CopyOperation)
	c:RegisterEffect(e9)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(Senya.DescriptionInNanahira(0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckReleaseGroup(tp,aux.FilterEqualFunction(Card.GetOriginalCode,37564765),1,nil) end
		local g=Duel.SelectReleaseGroup(tp,aux.FilterEqualFunction(Card.GetOriginalCode,37564765),1,1,nil)
		Duel.Release(g,REASON_COST)
	end)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return re:IsHasType(EFFECT_TYPE_ACTIVATE)
	end)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	if not cm.check then
		cm.check={e6,e7}
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_CHAIN_SOLVED)
		ge:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
			for i,te in pairs(cm.check) do
				if re==te then return false end
			end
			return true
		end)
		ge:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			cm.last_spell=re:GetHandler()
		end)
		Duel.RegisterEffect(ge,0)
	else
		table.insert(cm.check,e6)
		table.insert(cm.check,e7)
	end
end
function cm.scopytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=cm.last_spell
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,chkc))
	end
	if chk==0 then
		if not tc then return false end
		return cm.CopySpellNormalFilter(tc)
	end
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function cm.CopySpellChainingTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=cm.last_spell
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,chkc))
	end
	if chk==0 then
		if not tc then return false end
		return cm.CopySpellChainingFilter(tc,e,tp,eg,ep,ev,re,r,rp)
	end
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=cm.CopySpellNormalFilter(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(true,true,true)
	else
		te=tc:GetActivateEffect()
	end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		if fchain then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function cm.scopytg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local l=e:GetHandler():GetFlagEffectLabel(m)
	local tc=l and Senya.order_table[l]
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,chkc))
	end
	if chk==0 then
		if not tc then return false end
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return cm.CopySpellNormalFilter(tc)
	end
	e:SetLabel(0)
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function cm.scopytg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local l=e:GetHandler():GetFlagEffectLabel(m)
	local tc=l and Senya.order_table[l]
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,chkc))
	end
	if chk==0 then
		if not tc then return false end
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return cm.CopySpellChainingFilter(tc,e,tp,eg,ep,ev,re,r,rp)
	end
	e:SetLabel(0)
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=cm.CopySpellNormalFilter(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(true,true,true)
	else
		te=tc:GetActivateEffect()
	end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		if fchain then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function cm.CopyOperation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:GetHandler():ReleaseEffectRelation(e)
	end
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.CopySpellNormalFilter(c)
	return c:CheckActivateEffect(true,true,false)
end
function cm.CopySpellChainingFilter(c,e,tp,eg,ep,ev,re,r,rp)
	if c:CheckActivateEffect(true,true,false) then return true end
	local te=c:GetActivateEffect()
	if te:GetCode()~=EVENT_CHAINING then return false end
	local tg=te:GetTarget()
	if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
	return true
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,7,2850,2100,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,7,2850,2100,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,true,POS_FACEUP)
			c:AddMonsterAttributeComplete()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(37564765)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1,true)
			c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1,Senya.order_table_new(re:GetHandler()))
		Duel.SpecialSummonComplete()
	end
end