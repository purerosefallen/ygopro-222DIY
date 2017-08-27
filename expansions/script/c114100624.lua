--★決意のエンゲージ　チュチュ＆メリッサ
function c114100624.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,114000833,aux.FilterBoolFunction(Card.IsFusionSetCard,0x221),1,true,true)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c114100624.valcheck)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c114100624.atkcon)
	e3:SetOperation(c114100624.atkop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--add code
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_CODE)
	e4:SetValue(114000833)
	c:RegisterEffect(e4)
end
function c114100624.imfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_ZOMBIE)
end
function c114100624.valcheck(e,c)
	local g=c:GetMaterial()
	local atk=0
	--fusion monster check
	if not g:IsExists(c114100624.imfilter,1,nil) then
		atk=-1
	end
	--chuchu check
	if atk>=0 then
		local tc=g:GetFirst()
		if tc:IsCode(114000833) or tc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE) then tc=g:GetNext() end
		if not tc:IsCode(114000833) then
			atk=tc:GetTextAttack()
		end
	end
	e:SetLabel(atk)
end
function c114100624.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and e:GetHandler():GetMaterialCount()>0
end
function c114100624.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetLabelObject():GetLabel()
	if atk>=0 then
		if atk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(114100624,0))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c114100624.efilter)
		e2:SetOwnerPlayer(tp)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function c114100624.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end