--欧忒耳佩
function c98600002.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(98600002)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c98600002.fscon)
	e1:SetOperation(c98600002.fsop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c98600002.cointg)
	e1:SetOperation(c98600002.coinop)
	c:RegisterEffect(e1)
end
function c98600002.fscon(e,g,gc,chkfnf)
	if g==nil then return true end
	if gc then return false end
	local c=e:GetHandler()
	local tp=c:GetControler()
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,Group.CreateGroup(),c) then return false end
	local chkf=bit.band(chkfnf,0xff)
	return chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(chkf)>0
end
function c98600002.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	Duel.SetFusionMaterial(Group.CreateGroup())
end
function c98600002.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c98600002.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=1-Duel.TossCoin(tp,1)
	local list={
		[0]=EFFECT_CANNOT_BE_SYNCHRO_MATERIAL,
		[1]=EFFECT_CANNOT_BE_XYZ_MATERIAL,
	}
	c:RegisterFlagEffect(98600002,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98600002,res))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(list[res])
	e1:SetValue(1)
	c:RegisterEffect(e1)
end