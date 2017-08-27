--zone
local m=37564321
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.atktarget)
	c:RegisterEffect(e2)
	local t={EVENT_SUMMON_SUCCESS,EVENT_FLIP_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS}
	for i,v in pairs(t) do
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetCategory(CATEGORY_TOGRAVE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetProperty(0x14000)
		e1:SetRange(LOCATION_FZONE)
		e1:SetCode(v)
		e1:SetTarget(cm.tg)
		e1:SetOperation(cm.op)
		c:RegisterEffect(e1)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.atktarget(e,c)
	return not c:IsType(TYPE_TOKEN)
end
function cm.filter(c)
	return c:IsAbleToGrave()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.filter,1,e:GetHandler()) end
	local g=eg:Filter(cm.filter,e:GetHandler(),tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function cm.filter2(c,e)
	return c:IsAbleToGrave() and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter2,e:GetHandler(),e)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	local tokent={}
	while tc do
		local p=tc:GetControler()
		local atk=tc:GetTextAttack()
		local def=tc:GetTextDefense()
		local code=tc:GetOriginalCode()
		Duel.SendtoGrave(tc,REASON_EFFECT)
		table.insert(tokent,{p=tc:GetControler(),
							atk=tc:GetTextAttack(),
							def=tc:GetTextDefense(),
							code=tc:GetOriginalCode()})
		tc=g:GetNext()
	end
	for i,t in pairs(tokent) do
		if Duel.GetLocationCount(p,LOCATION_MZONE)>0 then
			local token=Duel.CreateToken(t.p,m+1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetValue(t.atk)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0xfe0000)
			token:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_BASE_DEFENSE)
			e2:SetValue(t.def)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+0xfe0000)
			token:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CHANGE_CODE)
			e3:SetValue(t.code)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetReset(RESET_EVENT+0xfe0000)
			token:RegisterEffect(e3,true)
			token:CopyEffect(t.code,RESET_EVENT+0xfe0000,1)
			Duel.MoveToField(token,t.p,t.p,LOCATION_MZONE,POS_FACEUP,true)
		end
	end
end